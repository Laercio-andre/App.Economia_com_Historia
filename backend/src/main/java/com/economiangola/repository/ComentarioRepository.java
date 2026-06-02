// src/main/java/com/economiangola/repository/ComentarioRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Comentario;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ComentarioRepository extends JpaRepository<Comentario, Long> {

    Page<Comentario> findByConteudoIdAndPaiIsNullAndDeletedAtIsNull(Long conteudoId, Pageable pageable);

    List<Comentario> findByConteudoIdAndPaiIsNullAndDeletedAtIsNullOrderByCriadoEmDesc(Long conteudoId);

    Optional<Comentario> findByIdAndDeletedAtIsNull(Long id);

    long countByConteudoIdAndDeletedAtIsNull(Long conteudoId);
}
