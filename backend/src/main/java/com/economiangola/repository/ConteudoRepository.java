// src/main/java/com/economiangola/repository/ConteudoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Conteudo;
import com.economiangola.domain.enums.StatusConteudo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConteudoRepository extends JpaRepository<Conteudo, Long> {

    Optional<Conteudo> findBySlug(String slug);

    boolean existsBySlug(String slug);

    Optional<Conteudo> findByIdAndDeletedAtIsNull(Long id);

    @Query("SELECT c FROM Conteudo c WHERE c.deletedAt IS NULL " +
            "AND (:status IS NULL OR c.status = :status) " +
            "AND (:categoriaId IS NULL OR c.categoria.id = :categoriaId) " +
            "AND (:autorId IS NULL OR c.autor.id = :autorId)")
    Page<Conteudo> buscarComFiltros(
            @Param("status") StatusConteudo status,
            @Param("categoriaId") Long categoriaId,
            @Param("autorId") Long autorId,
            Pageable pageable);

    Page<Conteudo> findByDeletedAtIsNullAndStatus(StatusConteudo status, Pageable pageable);
}
