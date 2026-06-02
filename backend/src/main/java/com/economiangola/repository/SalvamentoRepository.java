// src/main/java/com/economiangola/repository/SalvamentoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Salvamento;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SalvamentoRepository extends JpaRepository<Salvamento, Long> {

    Optional<Salvamento> findByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);

    boolean existsByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);

    Page<Salvamento> findByUsuarioId(Long usuarioId, Pageable pageable);

    void deleteByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);
}
