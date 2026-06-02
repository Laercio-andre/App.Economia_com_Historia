// src/main/java/com/economiangola/repository/ReacaoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Reacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ReacaoRepository extends JpaRepository<Reacao, Long> {

    Optional<Reacao> findByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);

    long countByConteudoId(Long conteudoId);

    void deleteByUsuarioIdAndConteudoId(Long usuarioId, Long conteudoId);
}
